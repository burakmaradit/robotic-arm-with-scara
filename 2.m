function myloopingFnc()
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

a1 = 0.400;
a2 = 0.250;
d1 = 0.250;
d4 = 0.050;


global KEY_IS_PRESSED
KEY_IS_PRESSED = 0;
gcf
set(gcf, 'KeyPressFcn', @myKeyPressFcn)



hold on;
grid on;
view([-37.5 30])

axis([-1 1 -1 1 0 0.3]);
xlabel('x');
ylabel('y');
zlabel('z');

time = 0;


while ~KEY_IS_PRESSED
    x = deg2rad(time);
    time = time + 1;
    
    px = 0.4*sin(x);
    py = 0.4;
    pz = abs(0.2*sin(x));
    
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
    
    d3 = pz;
    if d3 > D3_MAX
        d3 = D3_MAX;
    elseif d3 < D3_MIN
        d3 = D3_MIN;
    end
    
    
    plot3(px,py, (0.3-pz-d4),'o','LineWidth',2, 'Color', 'red');
    
    pause(0.01);
end
disp('loop ended')

function myKeyPressFcn(hObject, event)
global KEY_IS_PRESSED
KEY_IS_PRESSED = 1;
disp('key is pressed')
