clear; clc; close;

%% initialize
fig = figure(Name="picross");
ax = gca;

param = Parameter.get_parameter(file="samples/15/sample2.txt", ...
    save_video=false);
state = State.get_initial_state(param);
graphics = Draw.initialize(fig, ax, 0.5, param);

%% video setting
if param.save_video
    FPS = 60;

    video_folder = "Video/";
    if ~isfolder(video_folder)
        mkdir(video_folder);
    end

    filename = "Picross";

    t = datetime;
    t_string = sprintf("_%d%02d%02d_%02d%02d%02d", t.Year, t.Month, t.Day, t.Hour, t.Minute, int32(t.Second));

    graphics.video = VideoWriter(video_folder + filename + t_string + ".mp4", "MPEG-4");
    graphics.video.FrameRate = FPS;
    graphics.video.Quality = 100;

    graphics.video.open;

    frame = getframe(gcf);
    writeVideo(graphics.video, frame);
end
%% solving
stack_line_num = [];
stack_line = [];
stack_ind = 0;

while ~Util.check_all_complete(param, state)
    [state_nxt, flag] = Solver.branch_solver(param, state, graphics);

    if ~flag
        if stack_ind == 0
            disp("Cannot be solvable");
        else
        end
    else
        break;
    end
    disp(Util.check_all_complete(param, state))
end
if param.save_video
    graphics.video.close;
end