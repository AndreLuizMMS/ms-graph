<template>
  <div>
    <router-view />
  </div>
</template>

<script>
import { defineComponent } from 'vue';
import { RouterView } from 'vue-router';

export default defineComponent({
  components: {
    RouterView,
  }
});
</script>
