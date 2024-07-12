const fs = require("fs");
fs.readFile('./source/import.hx', (err, data) => {
if (err) throw err;
var importData = data.toLocaleString().split("\n");
var imports = [];
for (let line of importData)
    imports.push( createLine(line))

    fs.writeFile('./imports.data', imports.join("\n"), (err) =>{
        if (err) return console.log(err);
        console.log("saved");
    })
});
/**
 * @param line {string}
 */
function createLine(line) {
    if (line.length < 1)
    return "";
    if (line.startsWith("#"))
    return line;
    var e = line.split(".").pop().split(";")[0];
    return 'setVar(\'' + e + '\',' +e+ ");";

}