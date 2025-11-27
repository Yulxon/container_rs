use std::fs;
use std::path::Path;

use crate::errors::Errcode;
use nix::unistd::Pid;

const MEM_LIMIT: i64 = 1024 * 1024 * 1024;
const MAX_PID: u64 = 64;

pub fn restrict_resources(hostname: &String, pid: Pid) -> Result<(), Errcode> {
    log::debug!("Restricting resources for hostname {}", hostname);

    let cg_root = Path::new("/sys/fs/cgroup").join(hostname);

    // Create cgroup directory
    if let Err(e) = fs::create_dir(&cg_root) {
        log::error!("Failed to create cgroup directory: {}", e);
        return Err(Errcode::ResourcesError(()));
    }

    // memory limit: memory.max
    if let Err(e) = fs::write(cg_root.join("memory.max"), MEM_LIMIT.to_string()) {
        log::error!("Failed to set memory limit: {}", e);
        return Err(Errcode::ResourcesError(()));
    }

    // pids limit: pids.max
    if let Err(e) = fs::write(cg_root.join("pids.max"), MAX_PID.to_string()) {
        log::error!("Failed to set pids.max: {}", e);
        return Err(Errcode::ResourcesError(()));
    }

    // cpu: limit to 25% (example)
    if let Err(e) = fs::write(cg_root.join("cpu.max"), "25000 100000") {
        log::error!("Failed to set cpu.max: {}", e);
        return Err(Errcode::ResourcesError(()));
    }

    // Add task to cgroup: write pid to cgroup.procs
    let pid_raw = pid.as_raw();
    if let Err(e) = fs::write(cg_root.join("cgroup.procs"), pid_raw.to_string()) {
        log::error!("Failed to add pid {} to cgroup: {}", pid_raw, e);
        return Err(Errcode::ResourcesError(()));
    }

    Ok(())
}

pub fn clean_cgroups(hostname: &String) -> Result<(), Errcode> {
    log::debug!("Cleaning cgroups");

    let path = format!("/sys/fs/cgroup/{}", hostname);
    if let Err(e) = fs::remove_dir(path) {
        log::error!("Failed to remove cgroup directory: {}", e);
        return Err(Errcode::ResourcesError(()));
    }

    Ok(())
}
