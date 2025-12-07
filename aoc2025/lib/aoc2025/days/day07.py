import os


def part2(filename: str):
    with open(filename) as f:
        n = 0
        dp = None
        for line in f:
            if not dp:
                n = len(line)
                dp = [0] * n
                start_ind = line.find("S")
                dp[start_ind] = 1
            else:
                new_dp = [0] * n
                for i in range(n):
                    if line[i] == ".":
                        new_dp[i] += dp[i]
                    elif line[i] == "^":
                        new_dp[i - 1] += dp[i]
                        new_dp[i + 1] += dp[i]
                dp = new_dp

        assert dp
        return sum(dp)


if __name__ == "__main__":
    file = "inputs/day07_example.txt"
    eg = part2(file)
    assert eg == 40

    file = "inputs/day07.txt"
    res = part2(file)
    print(res)
