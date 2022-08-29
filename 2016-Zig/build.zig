const Builder = @import("std").build.Builder;

pub fn build(b: *Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();
    const root_src = "main.zig";

    const test_cmd = b.addTest(root_src);
    test_cmd.setBuildMode(mode);
    test_cmd.setTarget(target);

    const test_step = b.step("test", "Test all days");
    test_step.dependOn(&test_cmd.step);

    const exe = b.addExecutable("aoc_2016", root_src);
    const run_cmd = exe.run();
    exe.setBuildMode(mode);
    exe.setTarget(target);

    const run_step = b.step("run", "Run all days");
    run_step.dependOn(&run_cmd.step);
}
