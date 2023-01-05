import yaml
import sys
import os

def read(yaml_file):
    with open(yaml_file, "r") as stream:
        try:
            settings = yaml.safe_load(stream)
            return settings
        except yaml.YAMLError as exc:
            print(exc)

def testcase_name(yamls):
    for k, v in yamls.items():
        if k != 'bdd':
            return k 

def get_steps_detail(steps):
    info = []
    k = 0
    for i in steps:
        for j in i:
            if j == "input":
                desc = steps[k]['input']['desc']
                info.append('        ' + j + ' ' + desc + '\n')
            if j == "click":
                desc = steps[k]['click']['desc']
                info.append('        ' + j + ' ' + desc + '\n')
            if j == "check":
                desc = steps[k]['check']['desc']
                info.append('        ' + j + ' ' + desc + '\n')
            if j == "check_disapear":
                desc = steps[k]['check_disapear']['desc']
                info.append('        ' + j + ' ' + desc + '\n')
        k = k + 1
    return info

def write_info(feature_file, info):
    for i in info:
        feature_file.write(i)

def body(feature_file, body_list, step, yamls):
    for k, v in body_list[0].items():
        insert = '    ' + step + ' ' + v + '\n'
        feature_file.write(insert)
        testcase = testcase_name(yamls)
        for i in body_list[1:]:
            info = get_steps_detail(yamls[testcase][i])
            step_insert = '      ' + i + '\n'
            feature_file.write(step_insert)
            write_info(feature_file, info)

def feature_generate(yamls):
    feature_file = open("feature", "a")
    for i in yamls['bdd']['feature1']:
        for k, v in i.items():
            if k == 'feature':
                insert = 'Feature: ' + v + '\n'
                feature_file.write(insert)
            if k == 'scenario':
                feature_file.write('\n')
                insert = '  Scenario: ' + v + '\n'
                feature_file.write(insert)
            if k == 'given':
                body(feature_file, v, 'Given', yamls)
            if k == 'when':
                body(feature_file, v, 'When', yamls)
            if k == 'then':
                body(feature_file, v, 'Then', yamls)
    feature_file.write('\n')
    feature_file.close()

def generate_page(yaml_file):
    if os.path.exists('feature'):
        os.remove('feature')
    yamls = read(yaml_file)
    feature_generate(yamls)

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print('no argument')
        sys.exit()
    generate_page(sys.argv[1])

