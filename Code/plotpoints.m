% Example Mx3 array representing points in 3D space
% Plots the planned path vs actual points followed by the robot
points3D = points; % 

% Extract x and y coordinates from the Mx3 array
x = points3D(1:3000, 1);
y = points3D(1:3000, 2);
size(x)

for i = 1:3000
    x(i) = mapValues(x(i), -6, 7, 0, 1300);
    y(i) = mapValues(y(i), -2,5,800, 0);
end


load officemap.map % replace with any test case occupancy map
OfficeMap = binaryOccupancyMap(map)
show(OfficeMap)

% Define the A* path planner object
planner = plannerAStarGrid(OfficeMap);

% Define the path
y1 = int32(mapValues(-3, -6, 7, 0, 1300))
x1 = int32(mapValues(4, -2,5,800, 0))
y2 = int32(mapValues(6, -6, 7, 0, 1300))
x2 = int32(mapValues(0, -2,5,800, 0))


% Define the start and goal points
% start = [600 571];
% goal = [114 700];
start = [x1 y1];
goal = [x2 y2];
% goal1 = fliplr(goal);
path = plan(planner, start, goal); % calculating path using A-star algorithm

% Plot the path
show(planner)
hold on

% figure
%plot(waypoints(:, 2), waypoints(:, 1), 'bo', 'MarkerSize', 8, 'LineWidth', 1)
plot(x, y, 'bo', 'MarkerSize', 8, 'LineWidth', 1)
hold off

function mappedValue = mapValues(inputValue, inputMin, inputMax, outputMin, outputMax)
    % Map input values from one range to another

    % Check if inputValue is within the input range
    if inputValue < inputMin
        inputValue = inputMin;
    elseif inputValue > inputMax
        inputValue = inputMax;
    end

    % Perform the mapping
    mappedValue = ((inputValue - inputMin) / (inputMax - inputMin)) * (outputMax - outputMin) + outputMin;
end
