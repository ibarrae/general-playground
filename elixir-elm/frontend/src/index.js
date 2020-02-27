"use strict";

var { Elm } = require("./Main.elm");
const tokenKey = "my-session"
const flags = {
  mToken: localStorage.getItem(tokenKey),
  apiRoot: API_ROOT
};

const app = Elm.Main.init({ node: document.getElementById("root"), flags: flags });

app.ports.manageSession.subscribe((val) => {
  if (val) {
    localStorage.setItem(tokenKey, val)
  } else {
    localStorage.removeItem(tokenKey);
  }
  setTimeout(() => app.ports.onSessionChange.send(val), 0);
});

window.addEventListener("storage", (event) => {
  if (event.storageArea === localStorage && event.key === tokenKey) {
    app.ports.onSessionChange.send(event.newValue);
  }
}, false);
