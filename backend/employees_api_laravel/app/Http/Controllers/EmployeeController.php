<?php

namespace App\Http\Controllers;

use App\Models\Employee;
use Carbon\Carbon;
use Illuminate\Http\JsonResponse;
use Illuminate\Routing\Controller as BaseController;

class EmployeeController extends BaseController
{
    /**
     * GET /api/employees
     *
     * Flags employees in green when:
     * - active with the organization (is_active = true)
     * - joined more than 5 years ago (strictly more than 5 years)
     */
    public function index(): JsonResponse
    {
        $now = Carbon::now();

        $employees = Employee::query()
            ->select(['id', 'name', 'join_date', 'is_active'])
            ->orderBy('id')
            ->get()
            ->map(function (Employee $employee) use ($now) {
                $joinDate = $employee->join_date instanceof Carbon
                    ? $employee->join_date
                    : Carbon::parse($employee->join_date);

                $flagged = (bool) $employee->is_active
                    && $joinDate->lt($now->copy()->subYears(5)); // strict: more than 5 years

                return [
                    'id' => $employee->id,
                    'name' => $employee->name,
                    'join_date' => $joinDate->format('Y-m-d'),
                    'is_active' => (bool) $employee->is_active,
                    'flagged' => $flagged,
                    // Full years for display (integer).
                    'yearsAtOrg' => $joinDate->diff($now)->y,
                ];
            })
            ->values();

        return response()->json($employees, 200)
            ->header('Access-Control-Allow-Origin', '*')
            ->header('Access-Control-Allow-Methods', 'GET, OPTIONS')
            ->header('Access-Control-Allow-Headers', 'Content-Type');
    }
}

