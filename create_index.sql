CREATE PRIMARY INDEX `#primary` ON `robot`;
CREATE INDEX `doc_type_index` ON `robot`(`doc_type`);
CREATE INDEX `idx_meta_id` ON `robot`((meta().`id`));
CREATE INDEX `route_type` ON `robot`(`type`) WHERE (`doc_type` = "route");
CREATE INDEX `routine_execution_schedule` ON `robot`(`start_at` DESC,`id`) WHERE ((`doc_type` = "routine_execution") and ((`schedule`.`state`) = "ready"));
CREATE INDEX `routine_id_index` ON `robot`(`id`) WHERE (`doc_type` = "routine_execution");
CREATE INDEX `snap_routine_id` ON `robot`((`snap_routine`.`id`)) WHERE (`doc_type` = "routine_execution");
CREATE INDEX `robot_id` ON `robot` ( DISTINCT ARRAY robot_id FOR robot_id IN robot_ids END );
