import os
pot_files = "./pot/"
files_array = []
keys = {}

def main():
    files_array = os.listdir(pot_files)
    for filename in files_array:
        f = open(pot_files + filename,'r')
        lines = f.readlines()
        for line in lines:
            if("msgid" in line):
                key = line.split("\"")[1]
                if not key in keys:
                    keys[key] = {}
                    for file in files_array:
                        keys[key][file] = False
                keys[key][filename] = True
    print("===== SUMMARY =====")
    for key in keys:
        for filename in keys[key]:
            if(not keys[key][filename]):
                print(key + " not in " + filename)


if __name__ == "__main__":
    main()
