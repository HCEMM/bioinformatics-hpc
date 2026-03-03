#!/usr/bin/env python
import os, sys, time, random
from datetime import datetime
from colorama import Fore, Style, init

init()

patient_id = int(sys.argv[1])
random.seed(patient_id)

base_dir = os.environ.get("SUBMIT_DIR", ".")
output_dir = os.path.join(base_dir, f"patient_{patient_id}")
os.makedirs(output_dir, exist_ok=True)

log_file = os.path.join(output_dir, "log.txt")
nodename = os.uname().nodename

with open(log_file, "w") as f:
    f.write(f"{Fore.CYAN}[{nodename}] Starting tumor simulation for Patient {patient_id}{Style.RESET_ALL}\n")

for day in range(1, 21):
    size = 10 * (1.1 ** day) + random.uniform(-5, 5)
    prog = "#" * int(size / 3)
    status = f"[Day {day:02}] Tumor size: {size:.2f} mm  {Fore.GREEN}{prog}{Style.RESET_ALL}"

    with open(log_file, "a") as f:
        f.write(f"{datetime.now().strftime('%H:%M:%S')} | {status}\n")

    time.sleep(random.uniform(0.5, 1.5))

with open(log_file, "a") as f:
    f.write(f"{Fore.YELLOW}[{nodename}] Patient {patient_id} simulation complete ✅{Style.RESET_ALL}\n")
