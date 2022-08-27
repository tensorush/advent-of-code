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
        install_all_step.dependOn(&install_cmd.step);

        const test_cmd = b.addTest(day_file);
        test_all_step.dependOn(&test_cmd.step);
        test_cmd.setBuildMode(mode);
        test_cmd.setTarget(target);

        const run_cmd = exe.run();
        run_cmd.step.dependOn(&install_cmd.step);
        run_all_step.dependOn(&run_cmd.step);
    }
}
