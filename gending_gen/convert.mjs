import { parseArgs } from "node:util";
import { readFile, writeFile } from "node:fs/promises";

const { values: { input, output } } = parseArgs({
    options: {
        input: {
            type: "string",
            short: "i",
        },
        output: {
            type: "string",
            short: "o"
        }
    }
})

if (!input || !output) {
    console.log("Usage node ./convert.mjs -i input -o output");
}

const inputLines = (await readFile(input)).toString().split("\n");
const outputJson = {
    event: []
};

for (const line of inputLines) {
    for (const match of line.matchAll(/^[\w]+:|\.|\(\d\)|\d/g)) {
        const str = match[0];

        if (str.endsWith(":")) {
            outputJson.event.push({
                type: "text",
                value: str.substring(0, str.length - 1)
            });
        } else if (str == ".") {
            outputJson.event.push({
                type: "delay"
            });
        } else {
            const opt = str.startsWith("(");
            outputJson.event.push({
                type: "key",
                opt,
                value: parseInt(str.replace("(", "").replace("(", ""))
            })
        }
    }
}

await writeFile(output, JSON.stringify(outputJson, null, 4));