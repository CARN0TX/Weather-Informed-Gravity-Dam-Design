
%% Set up the Import Options and import the data
opts = spreadsheetImportOptions("NumVariables", 6);

% Specify sheet and range
opts.Sheet = "Given Data";
opts.DataRange = "B4:G15";

% Specify column names and types
opts.VariableNames = ["rainfall", "Tmax", "Tmin", "Windspeed", "Shortwave1", "Tdew"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double"];

% Import the data
tbl = readtable("C:\Users\Ravi\OneDrive\Desktop\Term Paper WRE_Term project_102001025.xlsx", opts, "UseExcel", false);

%% Convert to output type
rainfall = tbl.rainfall;
Tmax = tbl.Tmax;
Tmin = tbl.Tmin;
Windspeed = tbl.Windspeed;
Shortwave1 = tbl.Shortwave1;
Tdew = tbl.Tdew;

%% Clear temporary variables
clear opts tbl

%% latitude =8.7139° N, 77.7567° E, Altitude Z =47 m
% evaluation of parameters
%atmospheric pressure
z=47;
 P = 101.3*((293-0.0065*z)/293)^5.26;
 %% J values
J=[195,225,255,285,315,345,15,45,75,105,135,165];

%% ET values
ET = zeros(1,12);
%% initialising other parameters
a= 0.23;
Gamma = (0.665*P)/1000;
sigma = 4.903 *10^(-9);
Gsc = 0.0820;
phi = ((pi/180)*8.7139);
G=0;

%% finding other parameters

for  i = 1:12
    
T = (Tmax(i)+Tmin(i))/2;
dr = 1+(0.033*cos(2*pi*J(i)/365));
delta = 0.409*sin(((2*pi*J(i))/365)-1.39);
ws = acos(-tan(phi)*tan(delta));
%Slope of saturation vapour pressure curve
Del = 4098*(0.6108*exp((17.27*T)/(T+237.3)))/((T+237.3)^2); 

%To find vapor pressure deficit
es = (Vap(Tmax(i))+ Vap(Tmin(i)))/2;
ea = Vap(Tdew(i));


%to find radiation

Ra = ((24*60)/pi)*Gsc*dr*((ws*sin(phi)*sin(delta))+(cos(phi)*cos(delta)*sin(ws)));
 Rso = (0.75+((2*z)/100000))*Ra;
 Rns = (1-a)*Shortwave1(i);
 Rnl =sigma*((((Tmax(i)+273.16)^4)+((Tmin(i)+273.16)^4))/2)*(0.34-(0.14*sqrt(ea)))*((1.35*(Shortwave1(i)/Rso))-0.35);
 Rn = Rns-Rnl;
 %G=0 during day hence Rn-G= Rn
 % finding ET0
ET(i)=((0.408*Del*(Rn-G))+((Gamma*900*Windspeed(i)*(es-ea))/(T+273)))/((Gamma*(1+0.34*Windspeed(i)))+Del);

end 

 %% Displaying the values of ETo
 for i =1:12
     disp(ET(i));
 end
%% functions

function e = Vap(y)
    e=0.6108*exp((17.27*y)/(y+237.3));
        
end
