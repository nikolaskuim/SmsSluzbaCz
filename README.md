#Simple Perl Module for sms messaging with sms.sluzba.cz

This module can send SMS to recipients via API calls to sms.sluzba.cz.

dependencies:
- [LWP::UserAgent](http://search.cpan.org/~ether/libwww-perl-6.15/lib/LWP/UserAgent.pm)
- [Text::Unaccent](http://search.cpan.org/~ldachary/Text-Unaccent-1.08/Unaccent.pm)
- [XML::Simple](http://search.cpan.org/~grantm/XML-Simple-2.22/lib/XML/Simple.pm)


## Setup

```perl
my $smsManager = SmsSluzbaCz->new(username => 'username', password => 'password');
```

## Check status
```perl
my $info = $smsManager->accountInfo();
print Dumper($info);
```

## Send a message to a recipient
```perl
my $smsStatus = $smsManager->sendSms(recipient => $phone, message => $message);
print Dumper($smsStatus);
```

## Is message delivered?
```perl
my $deliveredStatus = $smsManager->deliveryReport(messageId => '420777777777-20161027153953608');
print Dumper($deliveredStatus);
```

## Send single message to multiple recipients
```perl
my @numbers = ('777777777', '608000000');
my $message = "Test";
my $smsStatusMultiple = $smsManager->sendSmsToMultipleRecipients(recipients => \@numbers, message => $message);
print Dumper($smsStatusMultiple);
```

## Fetch a list of responses from the server, count parameter sets the list size (default 30)
```perl
my $responses = $smsManager->fetchResponses(count => 10);
print Dumper($responses);
```

## Dismiss a message from the server
```perl
my $dismiss = $smsManager->dismissResponse(messageId => '420777777777-20160609200936203');
print Dumper($dismiss);
```
