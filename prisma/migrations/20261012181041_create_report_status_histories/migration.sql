-- CreateTable
CREATE TABLE "report_status_histories" (
    "id" TEXT NOT NULL,
    "report_id" TEXT NOT NULL,
    "status" "REPORT_STATUS" NOT NULL,
    "approver_id" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "report_status_histories_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "report_status_histories" ADD CONSTRAINT "report_status_histories_report_id_fkey" FOREIGN KEY ("report_id") REFERENCES "reports"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "report_status_histories" ADD CONSTRAINT "report_status_histories_approver_id_fkey" FOREIGN KEY ("approver_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
