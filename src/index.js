import "./index.css";

import { Elm } from "./Main.elm";

import Session from "./Session";
import UiShare from "./Ui/Share";
import UiTime from "./Ui/Time";

const flags = {};
const app = Elm.Main.init({
  node: document.querySelector("main"),
  flags: flags,
});

Session.start(app);
UiShare.start(app);
UiTime.start(app);
