function myLoopingFcn() 

THETA1_MAX = deg2rad(200); 
THETA1_MIN = deg2rad(0);
THETA2_MAX = deg2rad(135);
THETA2_MIN = deg2rad(0);
D3_MAX = 0.200; 
D3_MIN = 0.00;
THETA4_MAX = deg2rad(180);
THETA4_MIN = deg2rad(-180);


MIN_SCARA = 0.28;
MAX_SCARA = 0.65;
MIN_USER = 0.25;
MAX_USER = 0.50;


a1 = 0.400; %0.700 
a2 = 0.250; %0.530 
d1 = 0.250; 
d4 = 0.050;

%% matlab'ın tam sürüm olması gerekiyor / matlab needs to be the full version
  % [alpha a theta d R/P]
  
 L0 = link[0 0 0 d1 0];
                                   
 L1 = link[pi a1 0 0 0]; 
 L2 = link[0 a2 0 0 0];  
 L3 = link[0 0 0 0 1];   
 L4 = link[0 0 0 d4 0]; 
 

BUFFER_SIZE = 21;
global KEY_IS_PRESSED
KEY_IS_PRESSED = 0;
gcf
set(gcf, 'KeyPressFcn', @myKeyPressFcn)
t = tcpip('192.168.27.101', 23, 'NetworkRole', 'server');
fopen(t);


%% scara simulasyonu icin / for scara simulation

scara = robot({L0 L1 L2 L3 L4});
scara.name = 'SCARA';


hold on;
grid on;
view([-37.5 30])    
%view([0 90])        
axis([-1 1 -1 1 0 0.3]);
xlabel('x');
ylabel('y');
zlabel('z');


while ~KEY_IS_PRESSED
% while true
     
%       data = char(data');
%       S = strtrim(data)
      data = fread(t,BUFFER_SIZE);
      data = char(data);
      [pxt,pyt,pzt] = strread(data,'%f%f%f','delimiter',';');
      pxt
      pyt
      pzt
      py=1.3*pzt;
      %py = pzt*MIN_SCARA/MIN_USER + (pzt - MIN_USER)*0.36;
      px=1.3*pyt;
      %px = pyt*MIN_SCARA/MIN_USER + (pyt - MIN_USER)*0.36;
     
      pz=-pxt/3+0.1;
      
      
%       T = [1 0 0 px; 0 1 0 py; 0 0 1 pz; 0 0 0 1];
%       Q = ikine(scara, T);
      theta2 = acos((px^2+py^2-a1^2-a2^2)/(2*a1*a2));
      beta = atan(py/px);
      if beta < 0
          beta = beta + pi;
      end
      phi = acos((px^2+py^2+a1^2-a2^2)/(2*sqrt(px^2+py^2)*a1));
      theta1 = beta + phi;
      
      if theta1 > THETA1_MAX
          theta1 = THETA1_MAX;
      elseif theta1 < THETA1_MIN
          theta1 = THETA1_MIN;
      end
      
      if theta2 > THETA2_MAX
          theta2 = THETA2_MAX;
      elseif theta2 < THETA2_MIN
          theta2 = THETA2_MIN;
      end
      
      d3 = pz;
      if d3 > D3_MAX
          d3 = D3_MAX;
      elseif d3 < D3_MIN
          d3 = D3_MIN;
      end
      
      plot(scara, [0 theta1 theta2 d3 0]);
      
     % plot(data);
     % disp('yukleniyor...')
     flushinput(t);
      pause(0.01);
end
fclose(t);
disp('loop ended')

function myKeyPressFcn(hObject, event)
global KEY_IS_PRESSED
KEY_IS_PRESSED  = 1;
disp('key is pressed') 
