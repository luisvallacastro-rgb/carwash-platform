CREATE TABLE `audit_logs` (
	`id` text PRIMARY KEY NOT NULL,
	`actor_user_id` text,
	`action` text NOT NULL,
	`entity_type` text NOT NULL,
	`entity_id` text,
	`before` text,
	`after` text,
	`ip_hash` text,
	`user_agent` text,
	`created_at` integer NOT NULL,
	FOREIGN KEY (`actor_user_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `audit_entity_idx` ON `audit_logs` (`entity_type`,`entity_id`);--> statement-breakpoint
CREATE INDEX `audit_actor_created_idx` ON `audit_logs` (`actor_user_id`,`created_at`);--> statement-breakpoint
CREATE TABLE `business_settings` (
	`key` text PRIMARY KEY NOT NULL,
	`value` text NOT NULL,
	`is_public` integer DEFAULT false NOT NULL,
	`updated_by_user_id` text,
	`updated_at` integer NOT NULL,
	FOREIGN KEY (`updated_by_user_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `contact_messages` (
	`id` text PRIMARY KEY NOT NULL,
	`name` text NOT NULL,
	`contact` text NOT NULL,
	`message` text NOT NULL,
	`status` text DEFAULT 'new' NOT NULL,
	`created_at` integer NOT NULL
);
--> statement-breakpoint
CREATE TABLE `customers` (
	`id` text PRIMARY KEY NOT NULL,
	`user_id` text NOT NULL,
	`notification_preferences` text,
	`loyalty_visits` integer DEFAULT 0 NOT NULL,
	`created_at` integer NOT NULL,
	`updated_at` integer NOT NULL,
	`deleted_at` integer,
	FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE UNIQUE INDEX `customers_user_uq` ON `customers` (`user_id`);--> statement-breakpoint
CREATE TABLE `employee_assignments` (
	`id` text PRIMARY KEY NOT NULL,
	`order_id` text NOT NULL,
	`employee_id` text NOT NULL,
	`assigned_by_user_id` text NOT NULL,
	`assigned_at` integer NOT NULL,
	`ended_at` integer,
	FOREIGN KEY (`order_id`) REFERENCES `service_orders`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`employee_id`) REFERENCES `employees`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`assigned_by_user_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `assignments_order_idx` ON `employee_assignments` (`order_id`);--> statement-breakpoint
CREATE INDEX `assignments_employee_idx` ON `employee_assignments` (`employee_id`);--> statement-breakpoint
CREATE TABLE `employees` (
	`id` text PRIMARY KEY NOT NULL,
	`user_id` text NOT NULL,
	`employee_code` text NOT NULL,
	`specialty` text,
	`status` text DEFAULT 'active' NOT NULL,
	`created_at` integer NOT NULL,
	`updated_at` integer NOT NULL,
	`deleted_at` integer,
	FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE UNIQUE INDEX `employees_user_uq` ON `employees` (`user_id`);--> statement-breakpoint
CREATE UNIQUE INDEX `employees_code_uq` ON `employees` (`employee_code`);--> statement-breakpoint
CREATE TABLE `notification_logs` (
	`id` text PRIMARY KEY NOT NULL,
	`notification_id` text NOT NULL,
	`channel` text NOT NULL,
	`status` text NOT NULL,
	`attempt` integer DEFAULT 1 NOT NULL,
	`provider_reference` text,
	`error` text,
	`attempted_at` integer NOT NULL,
	FOREIGN KEY (`notification_id`) REFERENCES `notifications`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `notification_logs_status_idx` ON `notification_logs` (`status`,`attempted_at`);--> statement-breakpoint
CREATE TABLE `notifications` (
	`id` text PRIMARY KEY NOT NULL,
	`user_id` text NOT NULL,
	`order_id` text,
	`type` text NOT NULL,
	`title` text NOT NULL,
	`message` text NOT NULL,
	`read_at` integer,
	`created_at` integer NOT NULL,
	FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`order_id`) REFERENCES `service_orders`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `notifications_user_read_idx` ON `notifications` (`user_id`,`read_at`);--> statement-breakpoint
CREATE TABLE `order_items` (
	`id` text PRIMARY KEY NOT NULL,
	`order_id` text NOT NULL,
	`service_id` text NOT NULL,
	`quantity` integer DEFAULT 1 NOT NULL,
	`unit_price` real NOT NULL,
	`discount` real DEFAULT 0 NOT NULL,
	`subtotal` real NOT NULL,
	`created_at` integer NOT NULL,
	`updated_at` integer NOT NULL,
	`deleted_at` integer,
	FOREIGN KEY (`order_id`) REFERENCES `service_orders`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`service_id`) REFERENCES `services`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `order_items_order_idx` ON `order_items` (`order_id`);--> statement-breakpoint
CREATE TABLE `order_status_history` (
	`id` text PRIMARY KEY NOT NULL,
	`order_id` text NOT NULL,
	`previous_stage_id` text,
	`new_stage_id` text,
	`changed_by_user_id` text NOT NULL,
	`internal_comment` text,
	`client_comment` text,
	`evidence_url` text,
	`estimated_at` integer,
	`created_at` integer NOT NULL,
	FOREIGN KEY (`order_id`) REFERENCES `service_orders`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`previous_stage_id`) REFERENCES `service_stages`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`new_stage_id`) REFERENCES `service_stages`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`changed_by_user_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `history_order_created_idx` ON `order_status_history` (`order_id`,`created_at`);--> statement-breakpoint
CREATE TABLE `payments` (
	`id` text PRIMARY KEY NOT NULL,
	`order_id` text NOT NULL,
	`method` text NOT NULL,
	`amount` real NOT NULL,
	`status` text NOT NULL,
	`reference` text,
	`paid_at` integer,
	`created_at` integer NOT NULL,
	`updated_at` integer NOT NULL,
	`deleted_at` integer,
	FOREIGN KEY (`order_id`) REFERENCES `service_orders`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `payments_order_idx` ON `payments` (`order_id`);--> statement-breakpoint
CREATE TABLE `permissions` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`key` text NOT NULL,
	`description` text,
	`created_at` integer NOT NULL,
	`updated_at` integer NOT NULL,
	`deleted_at` integer
);
--> statement-breakpoint
CREATE UNIQUE INDEX `permissions_key_unique` ON `permissions` (`key`);--> statement-breakpoint
CREATE TABLE `promotion_redemptions` (
	`id` text PRIMARY KEY NOT NULL,
	`promotion_id` text NOT NULL,
	`order_id` text NOT NULL,
	`customer_id` text NOT NULL,
	`amount` real NOT NULL,
	`redeemed_at` integer NOT NULL,
	FOREIGN KEY (`promotion_id`) REFERENCES `promotions`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`order_id`) REFERENCES `service_orders`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`customer_id`) REFERENCES `customers`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE UNIQUE INDEX `redemptions_order_promo_uq` ON `promotion_redemptions` (`order_id`,`promotion_id`);--> statement-breakpoint
CREATE INDEX `redemptions_customer_idx` ON `promotion_redemptions` (`customer_id`);--> statement-breakpoint
CREATE TABLE `promotion_services` (
	`promotion_id` text NOT NULL,
	`service_id` text NOT NULL,
	PRIMARY KEY(`promotion_id`, `service_id`),
	FOREIGN KEY (`promotion_id`) REFERENCES `promotions`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`service_id`) REFERENCES `services`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `promotions` (
	`id` text PRIMARY KEY NOT NULL,
	`name` text NOT NULL,
	`description` text NOT NULL,
	`code` text,
	`discount_type` text NOT NULL,
	`discount_value` real NOT NULL,
	`status` text NOT NULL,
	`starts_at` integer,
	`ends_at` integer,
	`usage_limit` integer,
	`per_customer_limit` integer,
	`conditions` text,
	`created_at` integer NOT NULL,
	`updated_at` integer NOT NULL,
	`deleted_at` integer
);
--> statement-breakpoint
CREATE UNIQUE INDEX `promotions_code_uq` ON `promotions` (`code`);--> statement-breakpoint
CREATE INDEX `promotions_status_dates_idx` ON `promotions` (`status`,`starts_at`,`ends_at`);--> statement-breakpoint
CREATE TABLE `reviews` (
	`id` text PRIMARY KEY NOT NULL,
	`order_id` text NOT NULL,
	`customer_id` text NOT NULL,
	`rating` integer NOT NULL,
	`comment` text,
	`is_published` integer DEFAULT false NOT NULL,
	`created_at` integer NOT NULL,
	`updated_at` integer NOT NULL,
	`deleted_at` integer,
	FOREIGN KEY (`order_id`) REFERENCES `service_orders`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`customer_id`) REFERENCES `customers`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE UNIQUE INDEX `reviews_order_uq` ON `reviews` (`order_id`);--> statement-breakpoint
CREATE TABLE `role_permissions` (
	`role_id` integer NOT NULL,
	`permission_id` integer NOT NULL,
	PRIMARY KEY(`role_id`, `permission_id`),
	FOREIGN KEY (`role_id`) REFERENCES `roles`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`permission_id`) REFERENCES `permissions`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `roles` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`name` text NOT NULL,
	`description` text,
	`created_at` integer NOT NULL,
	`updated_at` integer NOT NULL,
	`deleted_at` integer
);
--> statement-breakpoint
CREATE UNIQUE INDEX `roles_name_unique` ON `roles` (`name`);--> statement-breakpoint
CREATE TABLE `service_orders` (
	`id` text PRIMARY KEY NOT NULL,
	`code` text NOT NULL,
	`customer_id` text NOT NULL,
	`vehicle_id` text NOT NULL,
	`current_stage_id` text,
	`status` text NOT NULL,
	`received_at` integer NOT NULL,
	`estimated_at` integer,
	`completed_at` integer,
	`delivered_at` integer,
	`progress` integer DEFAULT 0 NOT NULL,
	`total` real NOT NULL,
	`payment_status` text DEFAULT 'pending' NOT NULL,
	`pickup_code_hash` text,
	`client_notes` text,
	`version` integer DEFAULT 1 NOT NULL,
	`created_at` integer NOT NULL,
	`updated_at` integer NOT NULL,
	`deleted_at` integer,
	FOREIGN KEY (`customer_id`) REFERENCES `customers`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`current_stage_id`) REFERENCES `service_stages`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE UNIQUE INDEX `orders_code_uq` ON `service_orders` (`code`);--> statement-breakpoint
CREATE INDEX `orders_customer_idx` ON `service_orders` (`customer_id`);--> statement-breakpoint
CREATE INDEX `orders_vehicle_idx` ON `service_orders` (`vehicle_id`);--> statement-breakpoint
CREATE INDEX `orders_status_received_idx` ON `service_orders` (`status`,`received_at`);--> statement-breakpoint
CREATE TABLE `service_stages` (
	`id` text PRIMARY KEY NOT NULL,
	`service_id` text,
	`key` text NOT NULL,
	`name` text NOT NULL,
	`display_order` integer NOT NULL,
	`weight` integer DEFAULT 1 NOT NULL,
	`is_special` integer DEFAULT false NOT NULL,
	`is_active` integer DEFAULT true NOT NULL,
	`created_at` integer NOT NULL,
	`updated_at` integer NOT NULL,
	`deleted_at` integer,
	FOREIGN KEY (`service_id`) REFERENCES `services`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `stages_service_order_idx` ON `service_stages` (`service_id`,`display_order`);--> statement-breakpoint
CREATE TABLE `services` (
	`id` text PRIMARY KEY NOT NULL,
	`name` text NOT NULL,
	`slug` text NOT NULL,
	`description` text NOT NULL,
	`image_url` text,
	`base_price` real NOT NULL,
	`estimated_minutes` integer NOT NULL,
	`vehicle_types` text,
	`is_active` integer DEFAULT true NOT NULL,
	`display_order` integer DEFAULT 0 NOT NULL,
	`created_at` integer NOT NULL,
	`updated_at` integer NOT NULL,
	`deleted_at` integer
);
--> statement-breakpoint
CREATE UNIQUE INDEX `services_slug_uq` ON `services` (`slug`);--> statement-breakpoint
CREATE INDEX `services_active_order_idx` ON `services` (`is_active`,`display_order`);--> statement-breakpoint
CREATE TABLE `users` (
	`id` text PRIMARY KEY NOT NULL,
	`role_id` integer NOT NULL,
	`name` text NOT NULL,
	`email` text NOT NULL,
	`phone` text NOT NULL,
	`password_hash` text NOT NULL,
	`status` text DEFAULT 'pending' NOT NULL,
	`verified_at` integer,
	`failed_attempts` integer DEFAULT 0 NOT NULL,
	`created_at` integer NOT NULL,
	`updated_at` integer NOT NULL,
	`deleted_at` integer,
	FOREIGN KEY (`role_id`) REFERENCES `roles`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE UNIQUE INDEX `users_email_uq` ON `users` (`email`);--> statement-breakpoint
CREATE UNIQUE INDEX `users_phone_uq` ON `users` (`phone`);--> statement-breakpoint
CREATE INDEX `users_role_idx` ON `users` (`role_id`);--> statement-breakpoint
CREATE TABLE `vehicles` (
	`id` text PRIMARY KEY NOT NULL,
	`customer_id` text NOT NULL,
	`plate` text NOT NULL,
	`brand` text NOT NULL,
	`model` text NOT NULL,
	`year` integer,
	`color` text,
	`type` text NOT NULL,
	`image_url` text,
	`notes` text,
	`is_primary` integer DEFAULT false NOT NULL,
	`is_active` integer DEFAULT true NOT NULL,
	`created_at` integer NOT NULL,
	`updated_at` integer NOT NULL,
	`deleted_at` integer,
	FOREIGN KEY (`customer_id`) REFERENCES `customers`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE UNIQUE INDEX `vehicles_plate_uq` ON `vehicles` (`plate`);--> statement-breakpoint
CREATE INDEX `vehicles_customer_idx` ON `vehicles` (`customer_id`);