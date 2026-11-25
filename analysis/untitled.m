road_displacement = ts2timetable(out.road_displacement);
passive_displacement = ts2timetable(out.passive_displacement);
body_displacement = ts2timetable(out.body_displacement);
pid_displacement = ts2timetable(out.pid_displacement);
controlforce = ts2timetable(out.control_force);
out.control_force
road1 = ts2timetable(out.simout);
road2 = ts2timetable(out.simout1);

body = ts2timetable(out.body);
road = ts2timetable(out.road);
pid = ts2timetable(out.pid);
uncontrolled = ts2timetable(out.non);

plot(uncontrolled.Time,uncontrolled.Passive,"black")
hold on
plot(body.Time,body.RL,"red")
plot(pid.Time,pid.PID,"b")
ylabel("Roughness of the road (m)")
xlabel("Time (s)")

force = ts2timetable(out.force);
plot(force.Time,force.Data)
ylabel("Control Force (N)")
xlabel("Time (s)")

acc_ddpg = ts2timetable(out.acc);
acc_pid = ts2timetable(out.acc_pid);
acc_passive = ts2timetable(out.acc_passive);

ylabel("Road Excitation (m)")
xlabel("Time (s)")