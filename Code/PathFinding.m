load officemap.mat % replace with any test case occupancy map
OfficeMap = binaryOccupancyMap(map)
show(OfficeMap)


y1 = mapValues(0, -6, 7, 0, 1300)
x1 = mapValues(0, -2,5,800, 0)
y2 = mapValues(1, -6, 7, 0, 1300)
y2 = mapValues(4, -2,5,800, 0)

room1 = [x1 y1]; % replace with workspace out variable from simulink for real time working
room2 = [x2 y2]
% Define the start and goal points
start = room1; 
goal = room2; % destination location labelled as landmark
% goal1 = fliplr(goal);


% Define the A* path planner object
planner = plannerAStarGrid(OfficeMap);

% Define the path
path = plan(planner, start, goal); % using A start to find path

% Plot the path
show(planner)
hold on
% plot(path(:,2),path(:,1),'r','LineWidth',2)
% hold off

% Plot waypoints on the path
numWaypoints = 10;
waypoints = interpolatePath(path, numWaypoints); % calculate waypoints to follow
% figure
%plot(waypoints(:, 2), waypoints(:, 1), 'bo', 'MarkerSize', 8, 'LineWidth', 1)
plot(points(:, 2), points(:, 1), 'bo', 'MarkerSize', 8, 'LineWidth', 1)
hold off

function waypoints = interpolatePath(path, numWaypoints)
    % Linearly interpolate between points on the path
    distances = cumsum([0; sqrt(diff(path(:, 1)).^2 + diff(path(:, 2)).^2)]);
    totalDistance = distances(end);
    
    % Interpolate
    interpDistances = linspace(0, totalDistance, numWaypoints);
    waypoints(:, 1) = interp1(distances, path(:, 1), interpDistances, 'linear');
    waypoints(:, 2) = interp1(distances, path(:, 2), interpDistances, 'linear');
    disp('Waypoints Coordinates:');
    disp(waypoints);
end

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
