pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root
    property int barCount: 40
    property var barLevels: {
        let initialLevels = [];
        for (let i = 0; i < barCount; i++) {
            initialLevels.push(0.0);
        }
        return initialLevels;
    }

readonly property string cavaConfig: [
    "[general]",
    "bars = " + root.barCount,
    "framerate = 60",
    "sensitivity = 100",
    "autosens = 1",
    "overshoot = 10",
    "noise_reduction = 65",
    "monstercat = 1",
    "waves = 1",

    "[output]",
    "method = raw",
    "raw_target = /dev/stdout",
    "data_format = ascii",
    "ascii_max_range = 1000",
    "bar_delimiter = 59"
    ].join("\n")

    Process {
        id: cavaProcess
        running: true
        command: ["bash", "-c", "cava -p <(printf '" + root.cavaConfig + "\\n')"]

        stdout: SplitParser {
            onRead: data => {
                let cleanData = data.trim();
                if (cleanData.length === 0)
                    return;
                let tokens = cleanData.split(";");
                let availableTokens = Math.min(tokens.length, root.barCount);
                let nextLevels = [];

                for (let i = 0; i < root.barCount; i++) {
                    let rawAmplitudes = i < availableTokens ? parseInt(tokens[i] || 0) : 0;
                    let normalizedLevels = Math.max(0.0, Math.min(1.0, rawAmplitudes / 1000.00));
                    nextLevels.push(normalizedLevels);
                }
                root.barLevels = nextLevels;
            }
        }
    }
}
