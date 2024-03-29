// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"
import socket from "./socket"
// Import the polls channel code to enable live polling
import LivePolls from "./poll";
LivePolls.connect(socket);
// Import the Chat Socket code to enable chat
import LiveChat from './chat';
LiveChat.loadChat(socket);

