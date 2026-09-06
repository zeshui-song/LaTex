import csv

TOTAL_TRIALS = 20
OUTPUT_FILE = "coin_toss_results.csv"

results = []

print(f"Starting experiment: {TOTAL_TRIALS} trials.")
print("Enter 'H'/'h' for Heads or 'T'/'t' for Tails for each flip.\n")

for trial in range(1, TOTAL_TRIALS + 1):
    tosses = []
    toss_count = 0
    print(f"--- Trial {trial} of {TOTAL_TRIALS} ---")

    while True:
        raw_flip = input(f"Flip {toss_count + 1} (H/T): ").strip()
        flip = raw_flip.upper()

        if flip not in ("H", "T"):
            print("Invalid input. Please enter 'H' or 'T'.")
            continue

        toss_count += 1
        tosses.append(flip)

        if flip == "H":
            print(
                f"First Head reached on toss {toss_count}! Trial {trial} complete.\n"
            )
            results.append(
                {
                    "trial": trial,
                    "flips_sequence": "".join(tosses),
                    "tosses_to_first_head_X": toss_count,
                }
            )
            break

# Save collected data to CSV
with open(OUTPUT_FILE, mode="w", newline="", encoding="utf-8") as f:
    writer = csv.DictWriter(
        f, fieldnames=["trial", "flips_sequence", "tosses_to_first_head_X"]
    )
    writer.writeheader()
    writer.writerows(results)

print(f"All 20 trials finished! Results saved to '{OUTPUT_FILE}'.")