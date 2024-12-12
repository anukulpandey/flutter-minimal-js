"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.helloWorld = void 0;
function helloWorld() {
    console.log("windows===",window);
    window['flutterJs'].postMessage('flutter js called from helloWorld');
    return "Hello, World3333!";
}
exports.helloWorld = helloWorld;
