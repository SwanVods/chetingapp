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
            <div class="d-flex justify-content-start mb-4" v-for="message in messages" :key="message">
              <div class="img_cont_msg">
                <img src="https://therichpost.com/wp-content/uploads/2020/06/avatar2.png"
                  class="rounded-circle user_img_msg">
              </div>
              <div class="msg_cotainer">
                <div class="msg_name">{{ message.username }}</div>
                {{ message.message }}
                <span class="msg_time">{{convertTime(message.created_at)}}</span>
              </div>
            </div>
          </div>
          <div class="card-footer">
            <form @submit.prevent="submit">
              <div class="input-group">
                <input class="form-control type_msg" placeholder="Type your message..." v-model="message"/>
                <modal v-model="username" />
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
  <Teleport to="body">
    <!-- use the modal component, pass in the prop -->
    <modal :show="showModal" @close="showModal = false">
      <template #header>
        <h3>custom header</h3>
      </template>
    </modal>
  </Teleport>

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
      showModal: true
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

      fetch('http://localhost:3000/api/v1/chat/show')
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
      console.log(message.value, username.value);
      await fetch('http://localhost:3000/api/v1/chat/create', {
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
    return { username, messages, message, submit }
  },
  
  updated() {
    this.scrollToEnd();
  },
  
  methods: {
    scrollToEnd: function () {
      var container = this.$refs.list;
        container.scrollTop = container.scrollHeight;
    },
    convertTime: function (time) {
      return moment(time).format('LT');
    }
  }
}

</script>