close all

team1 = struct('name','Team A','color',rand(1,3),'strategy',@robostrategy_good);
team2 = struct('name','Team B','color',rand(1,3),'strategy',@robostrategy_myrobot);
robotgame_main(team1,team2);