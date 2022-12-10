<template>
  <Transition name="modal">
    <div v-show="show" class="modal-mask">
      <div class="modal-wrapper">
        <div class="modal-container">
          <div class="modal-header">
            <h3>Enter a username</h3>
          </div>
          <div class="modal-body">
            <input type="text" placeholder="username" v-model="username" class="form-control input-modal" v-on:keyup.enter="onEnter" required>
          </div>
          <div class="modal-footer">
            <slot name="footer">
              <button class="modal-default-button" @click="$emit('close')">OK</button>
            </slot>
          </div>
        </div>
      </div>
    </div>
  </Transition>
</template>

<script>
import './start-modal.css'

export default {
  props: {
    show: Boolean,
    username: String
  },
  data() {
    return {
      username: '',
    }
  },
  methods: {
    onEnter: function() {
      if (this.username) {
        this.$emit('close')
      }
    }
  }
}
</script>
