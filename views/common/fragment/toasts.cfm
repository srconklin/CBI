
<!--- 'from-blue-500 to-blue-600': toast.type === 'info',
				'from-yellow-400 to-yellow-500': toast.type === 'warning',
				'from-red-500 to-pink-500': toast.type === 'error',
			 --->
<div x-data class="toast-container">
			<template
				x-for="(toast, index) in $store.toasts.list"
				:key="toast.id"
			>
				<div
					x-show="toast.visible"
					@click="$store.toasts.destroyToast(index)"
					x-transition:enter="toast-enter"
					x-transition:enter-start="toast-enter-start"
					x-transition:enter-end="toast-enter-end"
					x-transition:leave="toast-leave"
					x-transition:leave-start="toast-leave-start"
					x-transition:leave-end="toast-leave-end"
					class="toast"
					:class="{
						'toast-success': toast.type === 'success',
						'toast-info': toast.type === 'info',
					}"
				>
			
				<div class="toast-content">

							
					<svg
						x-show="toast.type == 'info'"
						xmlns="http://www.w3.org/2000/svg"
						viewBox="0 0 20 20"
						fill="currentColor"
					>
						<path
							fill-rule="evenodd"
							d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z"
							clip-rule="evenodd"
						/>
					</svg>
					<svg
						x-show="toast.type == 'success'"
						xmlns="http://www.w3.org/2000/svg"
						viewBox="0 0 20 20"
						fill="currentColor"
					>
						<path
							fill-rule="evenodd"
							d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"
							clip-rule="evenodd"
						/>
					</svg>
					<svg
						x-show="toast.type == 'warning'"
						xmlns="http://www.w3.org/2000/svg"
						viewBox="0 0 20 20"
						fill="currentColor"
					>
						<path
							fill-rule="evenodd"
							d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z"
							clip-rule="evenodd"
						/>
					</svg>
					<svg
						x-show="toast.type == 'error'"
						
						xmlns="http://www.w3.org/2000/svg"
						viewBox="0 0 20 20"
						fill="currentColor"
					>
						<path
							fill-rule="evenodd"
							d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z"
							clip-rule="evenodd"
						/>
					</svg>
					<div class="toast-text">
						<p class="title" x-text="toast.title"></p>
						<p class="message text-sm" x-html="toast.message"></p>
					</div>

					<div class="toast-dismiss">
						<button @click.prevent="$store.toasts.destroyToast(index)" >
							<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
							<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
							</svg>
						</button>
					</div>


					</div>
				</div>
			</template>
		</div>