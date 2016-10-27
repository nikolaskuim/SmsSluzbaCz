use strict;
use warnings;
use File::Basename;
use lib dirname (__FILE__); # or move the module to your libs folder
use smsSluzbaCz;
use Data::Dumper;

# Setup the service
my $smsManager = SmsSluzbaCz->new(username => 'username', password => 'password');

# Get account basic info
# my $info = $smsManager->accountInfo();
# print Dumper($info);

# # Send a single message
my $message = "Test";
my $phone = "731263945";
my $smsStatus = $smsManager->sendSms(recipient => $phone, message => $message);
print Dumper($smsStatus);

# is message delivered? (wait 8 seconds and check)
sleep(8);
my $messageId = $smsStatus->{message}->{id};
my $deliveredStatus = $smsManager->deliveryReport(messageId => $messageId);
print Dumper($deliveredStatus);


# send a message to multiple recipients
# a better foreach wrapper for the sendSms method
my $message2 = "Test 2";
my @numbers = ('777777777', '608000000');
my $smsStatusMultiple = $smsManager->sendSmsToMultipleRecipients(recipients => \@numbers, message => $message2);
print Dumper($smsStatusMultiple);

# Set a message as read on the server
my $dismiss = $smsManager->dismissResponse(messageId => '420773618251-20160609200936203');
print Dumper($dismiss);

# fetch a list of responses from the server
# count parameter sets the size of the list to be fetched, default 30
my $responses = $smsManager->fetchResponses(count => 10);
print Dumper($responses);

