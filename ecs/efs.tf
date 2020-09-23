resource "aws_efs_file_system" "foo" {
  tags = local.tags
}

resource "aws_efs_mount_target" "mount" {
  file_system_id = aws_efs_file_system.foo.id
  subnet_id      = var.subnet_ids[0]
}