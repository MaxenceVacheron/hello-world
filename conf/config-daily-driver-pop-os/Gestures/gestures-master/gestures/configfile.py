from subprocess import call, Popen
from os.path import isfile
from shutil import copyfile
from gestures.gesture import Gesture
from re import compile


class ConfigFileHandler:
    def __init__(self, path, version):
        self.userPath = path
        self.appVersion = version
        self.filePath = path + "/.config/libinput-gestures.conf"
        self.backupPath = path + "/.config/libinput-gestures.conf.bak"

    def createFileIfNotExisting(self):
        if(isfile(self.filePath)):
            return False
        else:
            try:
                f = open(self.filePath, "w+")
                f.write("# Generated by Gestures ")  # will be overwritten later, just temporary header
                f.close()
                return True
            except:
                return False

    def openFile(self):
        self.swipe_threshold = 0

        self.validSupportedRegex = compile(
            "^\s*(#D:\s)?gesture\s((swipe)\s(up|down|left|right)\s([3-4]\s)?|(pinch\s(in|out|clockwise|anticlockwise)\s([2-4]\s)?))\s*(.+)")
        self.validUnsupportedRegex = compile("^\s*device\s")
        self.validSwipeThresholdRegex = compile("^\s*swipe_threshold\s*(\d+)\s*$")
        try:
            self.file = open(self.filePath, "r+")
        except:
            raise Exception("err_file_open")

        self.rawLines = list(self.file)

        for n in range(len(self.rawLines)):
            if(self.rawLines[n][-1:] == '\n'):
                self.rawLines[n] = self.rawLines[n][:-1]

        self.fileLines = ["# Generated by Gestures " + self.appVersion + "  -->  https://gitlab.com/cunidev/gestures",
                          "# Manual editing might result in data loss!"]
        self.validUnsupportedLines = ["# Unsupported lines"]
        self.invalidLines = ["# Invalid lines"]
        self.gestures = []

        for line in self.rawLines:
            validLine = self.validSupportedRegex.match(line)
            if(validLine):
                line = line.replace('\t', ' ')
                line = line.split(' ')
                filter(None, line)

                enabled = True
                if(line[0] == "#D:"):
                    enabled = False
                    line.pop(0)

                type = line[1]
                direction = line[2]

                if(line[3].isnumeric()):
                    fingers = line[3]
                    command = ' '.join(line[4:])

                else:
                    fingers = 4
                    command = ' '.join(line[3:])

                curGesture = Gesture(
                    type, direction, command, fingers, enabled)
                self.gestures.append(curGesture)

            elif(self.validUnsupportedRegex.match(line)):
                self.validUnsupportedLines.append(line)

            elif(self.validSwipeThresholdRegex.match(line)):
                try:
                    swipe_threshold = int(self.validSwipeThresholdRegex.match(line)[1])
                    self.swipe_threshold = swipe_threshold
                except:
                    pass

            elif((line[:1] == "#") and not ("#I: " in line)) or (line == ""):
                pass
            else:
                if ("#I: " in line):
                    self.invalidLines.append(line)
                else:
                    self.invalidLines.append("#I: " + line)

    def reloadFile(self):
        self.file.close()
        self.openFile()

    def reloadProcess(self):
        try:
            print("Restarting process (in background)...")
            Popen(["libinput-gestures-setup", "restart"], shell=False)
            print("Process restarted!")
        except:
            raise Exception("err_exec")

    def save(self):
        self.fileLines.append('\n')
        self.fileLines.extend(self.invalidLines)
        self.fileLines.append('\n')
        self.fileLines.extend(self.validUnsupportedLines)

        if(self.swipe_threshold >= 0 and self.swipe_threshold <= 100):
            self.fileLines.append('\n# Swipe threshold (0-100)')
            self.fileLines.append("swipe_threshold " + str(self.swipe_threshold))

        self.fileLines.append('\n# Gestures')

        for curGesture in self.gestures:
            self.fileLines.append(curGesture.make())

        self.file.seek(0)
        self.file.write('\n'.join(self.fileLines))
        self.file.truncate()
        self.reloadFile()

    def backup(self):
        return self.exportFile(self.backupPath)

    def restore(self):
        try:
            copyfile(self.backupPath, self.filePath)
            return True
        except:
            return False
            
    def importFile(self, path):
        try:
            copyfile(path, self.filePath)
            return True
        except:
            return False
            
    def exportFile(self, path):
        try:
            copyfile(self.filePath, path)
            return True
        except:
            return False
    
    def isValid(self):
        if (len(self.rawLines) > 0):
            return "# Generated by Gestures " in self.rawLines[0]
        else:
            return False
