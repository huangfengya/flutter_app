# 将 assets/icons 下的 svg 文件添加到当前目录下的 icons.dart 中
# 位置在 "// ----------- line ---------------------" 这一行之上

import os
import re


def write_svg_filenames_to_file():
    svg_dir = '../../assets/icons'
    target_file = 'icons.dart'

    # 获取所有.svg文件的文件名
    svg_files = [f for f in os.listdir(svg_dir) if f.endswith('.svg')]

    if not os.path.exists(target_file):
        with open(target_file, 'w') as f:
            pass  # 如果文件不存在，先创建一个空文件

    with open(target_file, 'r') as file:
        lines = file.readlines()
        existing_filenames = []
        target_line_index = None
        # 提取文件中已有包含.svg的行的文件名部分（如down.svg）用于后续判断，并查找目标行索引
        for index, line in enumerate(lines):
            match = re.search(r'([^\/]+\.svg)', line)
            if match:
                existing_filenames.append(match.group(1))
            if '// ----------- line ---------------------' in line:
                target_line_index = index
                break
    new_insert_lines = []
    pubspecYaml_lines = []
    for svg_file in svg_files:
        if svg_file not in existing_filenames:
            # 使用三引号构建要插入的多行内容
            match = re.search(r'([^\.]+)\.svg', svg_file)
            insert_lines = f'''final Widget {match.group(1)} = SvgPicture.asset(
  'assets/icons/{svg_file}',
  semanticsLabel: "",
  width: 20,
  height: 20,
);
'''
            new_insert_lines.append(insert_lines)
            pubspecYaml_lines.append(f'''- assets/icons/{svg_file}''')

    # 这一行会直接打印出来，自己粘贴到 pubspec.yaml 中去
    for publine in pubspecYaml_lines:
        print(publine)

    with open(target_file, 'r+') as file:
        if target_line_index is not None:
            content_before_target = "".join(lines[:target_line_index])
            content_after_target = "".join(lines[target_line_index:])
            file.seek(0)
            file.write(content_before_target)
            for insert_line in new_insert_lines:
                file.write(insert_line + "\n")
            file.write(content_after_target)
        else:
            for insert_line in new_insert_lines:
                file.seek(0, 2)
                file.write(insert_line + "\n")

if __name__ == "__main__":
    write_svg_filenames_to_file()