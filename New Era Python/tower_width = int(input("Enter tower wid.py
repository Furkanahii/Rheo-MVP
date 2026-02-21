tower_width = int(input("Enter tower width: "))
tower_height = int(input("Enter tower height: "))
car_width = int(input("Enter car width: "))
#---------------HOMEWORK STARTS BELOW---------------#
roof_h = tower_width // 2
tower_lines = []


for i in range(roof_h):
    left_spaces = roof_h - i - 1
    inner = 0 if i == 0 else 2 * i
    
    line = (" " * left_spaces) + "/" + (" " * inner) + "\\"
    if len(line) < tower_width:
        line += " " * (tower_width - len(line))
    tower_lines.append(line)


if tower_height >= 2:
    tower_lines.append("X" * tower_width)
    for _ in range(tower_height - 2):
        tower_lines.append("|" + (" " * (tower_width - 2)) + "|")
    tower_lines.append("X" * tower_width)
elif tower_height == 1:
    tower_lines.append("X" * tower_width)


start_offset = 20
screen_w = max(tower_width, start_offset + car_width)
height = len(tower_lines)
car_bottom_y = height - 1 - 3
car_top_y = car_bottom_y - 2
car_x = start_offset


while car_x + car_width > 0:
    frame = [[" "] * screen_w for _ in range(height)]

    
    for y in range(height):
        for x in range(min(len(tower_lines[y]), screen_w)):
            ch = tower_lines[y][x]
            if ch != " ":
                frame[y][x] = ch


    if car_top_y >= 0:
        top_s = "=" * car_width
        mid_s = "(" + (" " * (car_width - 2)) + ")"
        bot_s = "=" * car_width
        for i in range(car_width):
            dx = car_x + i
            if 0 <= dx < screen_w:
                if 0 <= car_top_y < height:
                    frame[car_top_y][dx] = top_s[i]
                if 0 <= car_top_y + 1 < height:
                    frame[car_top_y + 1][dx] = mid_s[i]  
                if 0 <= car_top_y + 2 < height:
                    frame[car_top_y + 2][dx] = bot_s[i]

    for row in frame:
        print("".join(row).rstrip())
    print()

    car_x -= 1


frame = [[" "] * screen_w for _ in range(height)]
for y in range(height):
    for x in range(min(len(tower_lines[y]), screen_w)):
        ch = tower_lines[y][x]
        if ch != " ":
            frame[y][x] = ch
for row in frame:
    print("".join(row).rstrip())

