package SmsSluzbaCz;
use utf8;
use warnings;
use strict;

use LWP::UserAgent;
use Text::Unaccent;
use XML::Simple;
use Data::Dumper;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

$VERSION     = 0.02;
@ISA         = qw(Exporter);
@EXPORT      = qw(new);
@EXPORT_OK   = qw(new);

use constant {
	SEND_URL => 'https://smsgateapi.sluzba.cz/apixml30/receiver',
	FETCH_URL => 'https://smsgateapi.sluzba.cz/apixml30/sender',
	INFO_URL => 'https://smsgateapi.sluzba.cz/apixml30/info/credit',
	CONFIRM_URL => 'https://smsgateapi.sluzba.cz/apixml30/confirm',
	DEFAULT_FETCH_COUNT => 30,
	AFF => '18845'
};

# Constructor
# var username string
# var password string
sub new {
	my $class = shift;
	my (%params) = @_;

	my $self = {
		username => $params{username},
		password => $params{password},
	};

	bless($self, $class);
	return($self);
}

# Request the server for the account info
# returns HASH on success, 0 on failure
sub accountInfo
{
	my ($self) = @_;

	# set custom HTTP request header fields
	my $url = $self->authUrl(url => INFO_URL);

	return $self->sendRequest(url => $url, method => 'POST');
}

sub sendRequest
{
	my $self = shift;
	my (%params) = @_;

	if (!$params{url}) {
		print "No url given!";
		return 0;
	}

	# defaults
	my $method = defined $params{method} ? $params{method} : 'POST';
	my $content = defined $params{content} ? $params{content} : ' '; #content must not be empty

	my $ua = LWP::UserAgent->new;
	
	my $req = HTTP::Request->new($method => $params{url});
	$req->header('content-type' => 'text/xml');

	$req->content($content); # length required
	my $resp = $ua->request($req);

	# print Dumper($resp);

	if ($resp->is_success) {
		my $xmlParser = XML::Simple->new();
		
		# the API has no response on a GET call so 
		# we artificialy create it
		if ($resp->decoded_content eq ' ') {
			return {status => 'OK'};
		}
		
		my $parsedData = $xmlParser->XMLin($resp->decoded_content);
		return $parsedData;
	} else {
		print "HTTPS POST error code: " . $resp->code . "\n";
		print "HTTPS POST error message: " . $resp->message . "\n";
		return 0;
	}

}

# Sends a message, 
# the recipient must by a valid phonenumber
# param1 string
# param2 string
# returns HASH on success, 0 on failure
sub sendSms {

	my $self = shift;
	my (%params) = @_;

	if (!$self->validRecipient($params{recipient})) {
		print "Invalid recipient: " . $params{recipient} . "\n";
		return 0;
	}

	# remove uccent characters
	my $message = $self->unaccentMessage($params{message});

	# add POST data to HTTP request body
	my $postData = $self->prepareXmlSendSms($params{recipient}, $message);

	# set custom HTTP request header fields
	my $url = $self->authUrl(url => SEND_URL);

	return $self->sendRequest(url => $url, method => 'POST', content => $postData);
		
}

# Sends an message to multiple recipients, 
# the recipient must by a valid phonenumber
# param1 string
# param2 array ref
# returns HASH of HASHES
sub sendSmsToMultipleRecipients
{
	my $self = shift;
	my (%params) = @_;

	# dereference the array
	my @recipients = @{$params{recipients}};

	my $results = {};

	foreach my $recipient (@recipients) {
		my $response = $self->sendSms(recipient => $recipient, message => $params{message});
		$results->{$recipient} = $response;
	}

	return $results;
}

#fetch a hash of responses from the server
#count int (count of messages to fetch)
#returns HASH or 0 on failure
sub fetchResponses
{
	my $self = shift;
	my (%params) = @_;

	my $count = defined $params{count} ? int($params{count}) : DEFAULT_FETCH_COUNT;

	my $ua = LWP::UserAgent->new;

	my $url = $self->authUrl(url => FETCH_URL) . "&count=" . $count;

	return $self->sendRequest(url => $url, method => 'POST');
}

#sets a message as read on the server
#messageId string
#returns HASH or 0 on failure
sub dismissResponse
{
	my $self = shift;
	my (%params) = @_;

	my $url = $self->authUrl(url => CONFIRM_URL) . "&type=incoming_message&id=" . $params{messageId};

	return $self->sendRequest(url => $url, method => 'GET');

}


# SMS API call to sms.sluzba.cz
sub prepareXmlSendSms {
	my ($self, $recipient, $message) = @_;

	my $data = '<?xml version="1.0" encoding="UTF-8"?>
				<outgoing_message>
					<text>' . $message . '</text>
					<recipient>' . $recipient  . '</recipient>
				</outgoing_message>';

	return $data;
}

# Regular expression taken from: https://php.vrana.cz/regularni-vyraz-pro-kontrolu-cisla.php (2016)
# param1 string
# returns bool
sub validRecipient
{
	my ($self, $string) = @_;

	return $string =~ m/^-?(0|[1-9][0-9]*|(?=\.))(\.[0-9]+)?$/;
}


	
sub authUrl
{
	my $self = shift;
	my (%params) = @_;

	return $params{url} . 
		"?login=" . $self->{username} . 
		"&password=" . $self->{password} . 
		"&affiliate=" . AFF;
}

# Unaccents a string
# param1 string
# returns bool
sub unaccentMessage
{
	my ($self, $message) = @_;
	return  unac_string("UTF-8", $message);
}

1;