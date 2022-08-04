const Builder = @import("std").build.Builder;

pub fn build(b: *Builder) void {
    const mode = b.standardReleaseOptions();
    const target = b.standardTargetOptions(.{});

    const run_all_step = b.step("run_all", "Run all days");
    const test_all_step = b.step("test_all", "Test all days");
    const install_all_step = b.step("install_all", "Install all days");

    var day: u8 = 1;
    while (day < 26) : (day += 1) {
        const str_day = b.fmt("day_{:0>2}", .{day});
        const day_file = b.fmt("src/{s}.zig", .{str_day});

        const exe = b.addExecutable(str_day, day_file);
        exe.setBuildMode(mode);
        exe.setTarget(target);

        const install_cmd = b.addInstallArtifact(exe);

        const run_cmd = exe.run();
        run_cmd.step.dependOn(&install_cmd.step);

        const test_cmd = b.addTest(day_file);
        test_cmd.setTarget(target);
        test_cmd.setBuildMode(mode);

        const run_step = b.step(b.fmt("run_{s}", .{str_day}), b.fmt("Run {s}", .{str_day}));
        run_step.dependOn(&run_cmd.step);
        run_all_step.dependOn(&run_cmd.step);

        const test_step = b.step(b.fmt("test_{s}", .{str_day}), b.fmt("Test {s}", .{str_day}));
        test_step.dependOn(&test_cmd.step);
        test_all_step.dependOn(&test_cmd.step);

        const install_step = b.step(b.fmt("install_{s}", .{str_day}), b.fmt("Install {s}", .{str_day}));
        install_step.dependOn(&install_cmd.step);
        install_all_step.dependOn(&install_cmd.step);
    }
}
