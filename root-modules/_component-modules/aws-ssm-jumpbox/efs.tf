resource "aws_efs_mount_target" "this" {
  for_each        = var.efs_mounts
  file_system_id  = each.value.file_system_id
  subnet_id       = var.subnet_id
  security_groups = [aws_security_group.this.id]
}

resource "aws_ssm_document" "attach_efs" {
  count = length(keys(var.efs_mounts)) == 0 ? 0 : 1

  name          = module.label_ssm_attach_efs[0].id
  document_type = "Command"
  target_type   = "/AWS::EC2::Instance"

  content = file("${path.module}/ssm-attach-efs.json")

  tags = module.label_ssm_attach_efs[0].tags
}

resource "aws_ssm_association" "attach_efs" {
  depends_on = [aws_instance.this]
  for_each   = var.efs_mounts
  name       = aws_ssm_document.attach_efs[0].name

  targets {
    key    = "InstanceIds"
    values = [aws_instance.this.id]
  }

  parameters = {
    mountPath     = each.value.mount_path
    accessPointId = each.value.access_point_id
    fileSystemId  = each.value.file_system_id
  }
}
