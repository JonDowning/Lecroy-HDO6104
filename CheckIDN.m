function [ID] = CheckIDN(DSO)

invoke(DSO,'WriteString','*IDN?',true); % Query the scope name and model number
ID=invoke(DSO,'ReadString',1000); % Read back the scope ID to verify connection

end