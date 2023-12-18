
ts1 = out.Basic;
ts2 = out.BasicWind;
ts3 = out.integral;

figure;
plot3(ts1.Data(:,1), ts1.Data(:,2), ts1.Data(:,3),'LineWidth', 2);

hold on; 
plot3(ts2.Data(:,1), ts2.Data(:,2), ts2.Data(:,3), 'LineWidth', 2);
hold on;
plot3(ts3.Data(:,1), ts3.Data(:,2), ts3.Data(:,3), 'LineWidth', 2);

title('Time evolution of the actual quadcopter position');
xlabel('X');
ylabel('Y');
zlabel('Z');
grid on;

legend('Basic', 'Basic+Wind', 'integral+Wind');
hold off;