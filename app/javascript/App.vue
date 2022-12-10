<template>
  <div class="container-fluid h-50">
    <div class="row justify-content-center h-100">
      <div class="mt-5 col-md-8 col-xl-6 chat">
        <div class="card">
          <div class="card-header msg_head">
            <div class="d-flex bd-highlight">
              <div class="img_cont">
                <img src="https://therichpost.com/wp-content/uploads/2020/06/avatar2.png"
                  class="rounded-circle user_img">
                <span class="online_icon"></span>
              </div>
              <div class="user_info">
                <span>Awesome Chat Room</span>
                <p>Made by Arief G</p>
              </div>
            </div>
          </div>
          <div class="card-body msg_card_body" ref="list">
            <div v-for="message in messages" :key="message">
              <div v-if="username !== message.username" class="d-flex justify-content-start mb-4" >
                <div class="img_cont_msg">
                  <img src="https://therichpost.com/wp-content/uploads/2020/06/avatar2.png"
                       class="rounded-circle user_img_msg" alt="foto user">
                </div>
                <div class="msg_cotainer">
                  <div class="msg_name">{{ message.username }}</div>
                  {{ message.message }}
                  <span class="msg_time">{{convertTime(message.created_at)}}</span>
                </div>
              </div>
              <div v-else class="d-flex justify-content-end mb-4">
                <div class="msg_cotainer_send">
                  <div class="msg_name_send">{{ message.username }}</div>
                  {{ message.message }}
                  <span class="msg_time_send">{{convertTime(message.created_at)}}</span>
                </div>
                <div class="img_cont_msg">
                  <img src="https://therichpost.com/wp-content/uploads/2020/06/avatar2.png" class="rounded-circle user_img_msg">
                </div>
              </div>

            </div>
          </div>
          <div class="card-footer">
            <form @submit.prevent="submit">
              <div class="input-group">
                <input class="form-control type_msg" placeholder="Type your message..." v-model="message" autofocus required>
                <button title="send" type="submit" class="input-group-append send_btn">
                  <i class="fas fa-location-arrow"></i>
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
  <Transition to="body">
    <modal :show="showModal" @close="showModal = false" ref="modal">
    </modal>
  </Transition>

</template>
<script>
//Bootstrap
import 'bootstrap/dist/css/bootstrap.min.css';
import 'bootstrap/dist/js/bootstrap.min.js';
import './App.css';
import 'jquery/dist/jquery.min.js';
import { ref, onMounted } from 'vue'
import Pusher from 'pusher-js'
import moment from 'moment'
import Modal from './components/start-modal.vue'

export default {
  name: 'App',
  components: {
    Modal
  },
  data() {
    return {
      showModal: true,
    }
  },
  setup() {
    const username = ref('');
    const messages = ref([]);
    const message = ref('');

    onMounted(() => {
      Pusher.logToConsole = false;

      const pusher = new Pusher('888672ef684a9abce21a', {
        cluster: 'ap1'
      });

      fetch('https://sea-lion-app-gp5j3.ondigitalocean.app/api/v1/chat/show')
        .then(res => res.json())
        .then(data => {
          messages.value = data;
        })

      const channel = pusher.subscribe('chetapp');
      channel.bind('messages', function (data) {
        messages.value.push(data);
      });
    });

    const submit = async () => {
      await fetch('https://sea-lion-app-gp5j3.ondigitalocean.app/api/v1/chat/create', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          username: username.value,
          message: message.value
        })
      });

      message.value = '';
    }
    return {username, messages, message, submit }
  },
  
  updated() {
    this.scrollToEnd();
    this.setUsername();
  },
  
  methods: {
    scrollToEnd: function () {
      const container = this.$refs.list;
      container.scrollTop = container.scrollHeight;
    },
    convertTime: function (time) {
      return moment(time).format('LT');
    },
    setUsername: function () {
      this.username = this.$refs.modal.username;
    },
    checkForm: function (e) {
      if (this.message) {
        return true;
      }

      this.errors = [];

      if (!this.name) {
        this.errors.push('Name required.');
      }
      if (!this.age) {
        this.errors.push('Age required.');
      }

      e.preventDefault();
    }
  },
}
</script>