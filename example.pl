use strict;
use warnings;
use File::Basename;
use lib dirname (__FILE__); # or move the module to your libs folder
use smsSluzbaCz;
use Data::Dumper;

my $message = "Test";
my $phone = "731263945";

my $smsManager = SmsSluzbaCz->new(username => 'username', password => 'password');

my $info = $smsManager->accountInfo();
print Dumper($info);

# my $smsStatus = $smsManager->sendSms(recipient => $phone, message => $message);
# print Dumper($smsStatus);


my @numbers = ('777777777', '608000000');
my $mess2 = "Test 2";
my $smsStatusMultiple = $smsManager->sendSmsToMultipleRecipients(recipients => \@numbers, message => $mess2);
print Dumper($smsStatusMultiple);

my $dismiss = $smsManager->dismissResponse(messageId => '420773618251-20160609200936203');
print Dumper($dismiss);

my $responses = $smsManager->fetchResponses(count => 10);
print Dumper($responses);