import json

def build_command(path):
  with open(path, "r") as read_file:
    config = json.load(read_file)
    cmd = "{}:assemble{}{}".format(config['module'],config['flavor'].capitalize() ,config['build_type'].capitalize() )
    if config['build_args']:
      cmd = cmd + ' ' + config['build_args'] 
    print(cmd)
    return cmd


def lint_command(path):
  with open(path, "r") as read_file:
    config = json.load(read_file)
    cmd = "{}:lint{}{}".format(config['module'],config['flavor'].capitalize() ,config['build_type'].capitalize() )
    print(cmd)
    return cmd

def tag_name(path):
  with open(path, "r") as read_file:
    config = json.load(read_file)
    tag_name = "{}_{}_{}/{}".format(config['module'],config['flavor'] ,config['build_type'], config['label'] )
    print(tag_name)
    return tag_name
