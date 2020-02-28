<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreatePreparedReportRequestsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('prepared_report_requests', function (Blueprint $table) {
            $table->increments('id');

            $table->string('access_key');
            $table->enum('status', ['pending', 'processing', 'done', 'cancel'])
                ->default('pending')
                ->nullable();
            $table->unsignedInteger('prepared_report_id')
                ->index();

            $table->timestamps();

            $table->foreign('prepared_report_id')
                ->references('id')
                ->on('prepared_reports')
                ->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('prepared_report_requests');
    }
}
