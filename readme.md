# locust_fargate

## 概要
- 負荷攻撃ツールLocustを、Fargate上で実行するためのTerraformスクリプトです

## 使い方
- cd ./locust_fargate/terraform
- terraform init
- terraform apply

## 変数設定
- general_name
  - リソースの名前などに使う文字列
  - 適当に変更して実行してください

- slave_count
  - スレイブコンテナの数

- fargate_cpu
  - コンテナのCPU
  - 256=.25vCPU

- fargate_memory
  - コンテナに割り当てるメモリ
  - MB

## トラブルシューティング
- Error: ClientException: No Fargate configuration exists for given values.
  - CPU, Memory の組み合わせが使えないものである可能性があります
  - https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/task-cpu-memory-error.html
