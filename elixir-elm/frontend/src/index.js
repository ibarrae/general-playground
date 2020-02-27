"use strict";

var { Elm } = require("./Main.elm");
const tokenKey = "my-token"
const flags = {
  mToken: localStorage.getItem(tokenKey),
  apiRoot: API_ROOT
};

const app = Elm.Main.init({ node: document.getElementById("root"), flags: flags });

app.ports.manageToken.subscribe((val) => {
  if (val) {
    localStorage.setItem(tokenKey, val)
  } else {
    localStorage.removeItem(tokenKey);
  }
  setTimeout(() => app.ports.onTokenChange.send(val), 0);
});

window.addEventListener("storage", (event) => {
  if (event.storageArea === localStorage && event.key === tokenKey) {
    app.ports.onTokenChange.send(event.newValue);
  }
}, false);
