#Simple Perl Module for sms messaging with sms.sluzba.cz

This module can send SMS to recipients via API calls to sms.sluzba.cz.

## Setup

```
my $smsManager = SmsSluzbaCz->new(username => 'username', password => 'password');
```

## Check status
```
my $info = $smsManager->accountInfo();
print Dumper($info);
```

## Send a message to a recipient
```
my $smsStatus = $smsManager->sendSms(recipient => $phone, message => $message);
print Dumper($smsStatus);
```

## Is message delivered?
```
my $deliveredStatus = $smsManager->deliveryReport(messageId => '420777777777-20161027153953608');
print Dumper($deliveredStatus);
```

## Send single message to multiple recipients
```
my @numbers = ('777777777', '608000000');
my $message = "Test";
my $smsStatusMultiple = $smsManager->sendSmsToMultipleRecipients(recipients => \@numbers, message => $message);
print Dumper($smsStatusMultiple);
```

## Fetch a list of responses from the server, count parameter sets the list size (default 30)
```
my $responses = $smsManager->fetchResponses(count => 10);
print Dumper($responses);
```

## Dismiss a message from the server
```
my $dismiss = $smsManager->dismissResponse(messageId => '420777777777-20160609200936203');
print Dumper($dismiss);
```