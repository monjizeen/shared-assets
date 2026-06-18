<script setup>
import AppLayout from '@/Layouts/AppLayout.vue';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { LogIn } from 'lucide-vue-next';
</script>

<template>
    <AppLayout>
        <Card class="mx-auto max-w-md text-center">
            <CardHeader>
                <CardTitle>Sign in</CardTitle>
                <CardDescription>Continue with your Google account.</CardDescription>
            </CardHeader>
            <CardContent class="space-y-4">
                <p v-if="$page.props.flash?.error" class="text-destructive text-sm">
                    {{ $page.props.flash.error }}
                </p>
                <Button as-child class="w-full">
                    <a :href="route('login.google')">
                        <LogIn class="size-4" />
                        Continue with Google
                    </a>
                </Button>
            </CardContent>
        </Card>
    </AppLayout>
</template>
