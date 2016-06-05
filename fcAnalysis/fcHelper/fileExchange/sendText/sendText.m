function [] = sendText(title,message)
%SENDTEXT send a text message

fcParamsObj = fcParams();
email = fcParamsObj.sendText_email;
password = fcParamsObj.sendText_password;
number = fcParamsObj.sendText_number;
carrier = fcParamsObj.sendText_carrier;
try
    myFunc = @(x) send_text_message(number,carrier,title,message,email,password);
    parfeval(gcp,myFunc,0);
catch
    warning('text did not go through');
end
end

