output "publicvmid1" {
  value = aws_instance.publicvm1.id
}
output "publicvmid2" {
  value = aws_instance.publicvm2.id
}
output "privatevmid1" {
  value = aws_instance.privatevm1.id
}
output "privatevmid2" {
  value = aws_instance.privatevm2.id
}