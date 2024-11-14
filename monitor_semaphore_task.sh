#!/bin/bash

# Semaphore API 地址和密钥
SEMAPHORE_API_URL="http://14.103.115.23:3003/api"
SEMAPHORE_API_KEY="lptxutxaaq3cy1mrrvonjiftifjevvxz-a5bhuiwegg="
TASK_ID="$1"  # 从命令行传递任务ID

# 检查输入任务ID是否为空
if [ -z "$TASK_ID" ]; then
  echo "请提供任务ID作为参数！"
  exit 1
fi

# 请求任务状态的函数
get_task_status() {
  local task_id=$1
  response=$(curl -s -H "Authorization: Bearer $SEMAPHORE_API_KEY" "$SEMAPHORE_API_URL/tasks/$task_id")

  # 提取任务状态
  status=$(echo "$response" | jq -r '.status')  # 使用 jq 提取 JSON 数据中的 status 字段
  echo "任务ID $task_id 的当前状态: $status"
}

# 主循环：每 10 秒检查一次任务状态
while true; do
  status=$(get_task_status "$TASK_ID")

  if [[ "$status" == "completed" ]]; then
    echo "任务 $TASK_ID 已完成！"
    # 在此添加任务完成后的操作，例如发送通知或执行其他命令
    break
  elif [[ "$status" == "failed" ]]; then
    echo "任务 $TASK_ID 失败！"
    # 在此添加任务失败后的操作
    break
  fi

  # 如果任务还在运行，等待 10 秒后重新检查
  echo "任务仍在运行，继续监控..."
  sleep 10
done
