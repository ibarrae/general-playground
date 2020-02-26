"use strict";

var { Elm } = require("./Main.elm");
const flags = {
  mToken: localStorage.getItem("my-token"),
  apiRoot: API_ROOT
};

Elm.Main.init({ node: document.getElementById("root"), flags: flags });
