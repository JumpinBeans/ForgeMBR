import requests
import hashlib
import json

# GitHub raw file URL
URL = "https://raw.githubusercontent.com/JumpinBeans/ForgeMBR/main/.soulchain"

# Simulated memory block
with open("kernel.bin", "rb") as f:
    kernel_data = f.read()

def calc_md5(data):
    return hashlib.md5(data).hexdigest()

def main():
    print("🔍 Fetching SoulChain Manifest from GitHub...")
    r = requests.get(URL)
    if r.status_code != 200:
        print("❌ Failed to fetch manifest.")
        return

    manifest = json.loads(r.text)
    expected_hash = manifest["block_0_hash"]
    actual_hash = calc_md5(kernel_data)

    print(f"Expected : {expected_hash}")
    print(f"Actual   : {actual_hash}")

    if actual_hash == expected_hash:
        print("✅ SoulChain Verified!")
    else:
        print("⚠️  SoulChain Mismatch — Audit Required.")

if __name__ == "__main__":
    main()
