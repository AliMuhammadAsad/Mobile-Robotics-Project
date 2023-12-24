function [LinVel, AngVel] = customPurePursuitController(Pose, waypoints)

    persistent lastGoal;
    persistent currentIndex;
    persistent i;

    if (isempty(currentIndex))
        currentIndex = 1;
    end

    if (isempty(i))
        i = 0;
    end
    
    
    % Persistent variable to store the last waypoint
    if (isempty(lastGoal))
        lastGoal = Pose(1:2);
    end

    x = waypoints(currentIndex, 1);
    y = waypoints(currentIndex, 2);
    currentGoal = [x; y];

    LinVel = 1;

    w = calculateCustomPurePursuit(Pose, lastGoal, currentGoal, LinVel);

    if (isAtGoalPoint(Pose, currentIndex, waypoints))
        lastGoal = currentGoal;
        if currentIndex ~= length(waypoints)
            currentIndex = currentIndex + 1;
            x = waypoints(currentIndex, 1);
            y = waypoints(currentIndex, 2);
            currentGoal = [x; y];
        end
    end

    AngVel = w;
    LinVel = 0.2;

end

function [reached] = isAtGoalPoint(robotPose, currentIndex, waypoints)
    % error limit that we are allowing
    goalRadius = 0.25;                       % locus of all points within the circle of radius 0.25 at goal point is considered goal point 
    xref = waypoints (currentIndex , 1);
    yref = waypoints (currentIndex , 2);
    
    % defining the rotation matrix
    R = [cos(robotPose(3)) sin(robotPose(3)); -sin(robotPose(3)) cos(robotPose(3))];

    % calculating and tranforming error between the current pose and the waypoint at
    % current index to robot frame(in terms of circle eq (x-h and y-k) 
    epsilon = R*([xref ; yref ]-robotPose(1:2));
    
    % calculating mean square error
    dist = sqrt((epsilon(1)).^2 + (epsilon(2)).^2);

    % checking if error is acceptable
    reached = dist < goalRadius;
end

function [angular_velocity] = calculateCustomPurePursuit(Pose, lastPoint, currentPoint, linearVelocity)
    lookaheadDistance = 1;

    % Calculate the goal point along the line segment based on the lookahead distance
    goalPoint = calculateGoalPoint(Pose, lastPoint, currentPoint, lookaheadDistance);
    display(goalPoint);

    % Calculating the vecor to goal (difference between
    % goalPoint(intersection point) and current pose
    vectorToGoal = goalPoint - [Pose(1); Pose(2)];

    % Defining the rotation matrix
    R = [cos(Pose(3)) sin(Pose(3)); -sin(Pose(3)) cos(Pose(3))];

    % Transforming the vector to robot frame
    vectorToGoal_robotFrame = R*vectorToGoal;

    % Calculating the curvature
    curvature = 2 * vectorToGoal_robotFrame(2) / lookaheadDistance;
    
    % scaling the curvature to calculate angular velocity
    angular_velocity = curvature * linearVelocity;
end

function [Chosen_Intersection_point] = calculateGoalPoint(Pose, lineSegmentStart, lineSegmentEnd, lookaheadDistance)
    % distance between pose and waypoint at current index is less than lookaheadDistance, we dont need to find intersection point
    if (distanceToGoalPoint(Pose(1:2), lineSegmentEnd) < lookaheadDistance)
        Chosen_Intersection_point = lineSegmentEnd;                
    else
        change = lineSegmentEnd - lineSegmentStart;
        vectorF = lineSegmentStart - Pose(1:2);

        a = sum(change .* change);
        b = 2 * sum(vectorF .* change);
        c = sum(vectorF .* vectorF) - lookaheadDistance.^2;
        discriminant = b.^2 - 4 * a .* c;

        Chosen_Intersection_point = [];
        Intersection_point1 = [];
        Intersection_point2 = [];
        if (discriminant < 0)
            % No intersection
        else
            discriminant = sqrt(discriminant);
            neg_discriminant = (-b - discriminant) / (2 * a);
            pos_discriminant = (-b + discriminant) / (2 * a);

            if (neg_discriminant >= 0 && neg_discriminant <= 1)
                % Return neg_discriminant intersection
                Intersection_point1 = lineSegmentStart + neg_discriminant .* change;
                % Assign in case pos_discriminant doesn't exist
                Chosen_Intersection_point = Intersection_point1;
            end

            if (pos_discriminant >= 0 && pos_discriminant <= 1)
                % Return pos_discriminant intersection
                Intersection_point2 = lineSegmentStart + pos_discriminant .* change;
                % Assign in case neg_discriminant doesn't exist
                Chosen_Intersection_point = Intersection_point2;
            end
        
            % if there are two intersection points chose one based on which is closer to the previous goalPoint
            if (~isempty(Intersection_point1) && ~isempty(Intersection_point2))
                if (distanceToGoalPoint(Intersection_point1, lineSegmentStart) < distanceToGoalPoint(Intersection_point2, lineSegmentStart))
                    Chosen_Intersection_point = Intersection_point1;
                else
                    Chosen_Intersection_point = Intersection_point2;
                end
            end
        end
    end
end


% A function that simply calculates distance
function [distance] = distanceToGoalPoint(current_point, goal_point)
    distance = sqrt((current_point(1) - goal_point(1)).^2 + (current_point(2) - goal_point(2)).^2);
end