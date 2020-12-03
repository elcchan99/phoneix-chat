import { Presence } from "phoenix";

let Chat = {
  init(socket) {
    if (!window.location.pathname.startsWith("/chat")) {
      return;
    }
    let path = window.location.pathname.split("/");
    let room = path[path.length - 1];
    let channel = socket.channel(`chat:${room}`, {
      token: window.userToken,
    });
    let presence = new Presence(channel);
    this.listenForPresence(presence);

    channel
      .join()
      .receive("ok", (resp) => {
        console.log(`Joined ${room} successfully`, resp);
      })
      .receive("error", (resp) => {
        console.log("Unable to join", resp);
      });

    this.listenForChats(channel);
  },

  getChatFormData() {
    return {
      name: document.getElementById("user-name").value,
      message: document.getElementById("user-message").value,
    };
  },

  cleanChatForm({ name: name }) {
    document.getElementById("user-name").value = name;
    document.getElementById("user-message").value = "";
  },

  addChatMessage({ name: name, message: message }) {
    let chatBox = document.querySelector("#chat-box");
    let msgBlock = document.createElement("p");

    msgBlock.insertAdjacentHTML("beforeend", `<b>${name}</b>: ${message}`);
    chatBox.appendChild(msgBlock);
  },

  constructOnlineStatus(onlineStatusObj) {
    console.log(onlineStatusObj);
    let ul = document.createElement("ul");
    Object.entries(onlineStatusObj).forEach(([name, status], _) => {
      console.log("name", name);
      console.log("status", status);
      let li = document.createElement("li");
      li.innerHTML = `<div class="icon icon-${status}line"></div><span>${name}<span>`;
      ul.appendChild(li);
    });
    return ul;
  },

  refreshOnlineStatus(onlineStatusObj) {
    let onlineStatus = document.querySelector(".online-status .content");
    onlineStatus.innerHTML = "";

    let ul = this.constructOnlineStatus(onlineStatusObj);
    onlineStatus.append(ul);
  },

  listenForChats(channel) {
    let that = this;
    function submitForm() {
      let chatData = that.getChatFormData();
      channel.push("shout", chatData);
      that.cleanChatForm(chatData);
    }

    document
      .getElementById("chat-form")
      .addEventListener("submit", function (e) {
        e.preventDefault();
        console.log(`form submitted: ${e}`, e);
        submitForm();
      });

    channel.on("shout", this.addChatMessage);
    // channel.on("online-status-update", this.refreshOnlineStatus);
  },
  renderOnlinePresence(presence) {
    let response = "";

    let onlineStatusObj = {};
    for (const [name, meta] of Object.entries(presence.state)) {
      onlineStatusObj[name] = "on";
    }
    let ul = this.constructOnlineStatus(onlineStatusObj);
    let onlineStatus = document.querySelector(".online-status .content");
    onlineStatus.innerHTML = "";
    onlineStatus.append(ul);
  },
  listenForPresence(presence) {
    presence.onSync(() => this.renderOnlinePresence(presence));
  },
};
export default Chat;
